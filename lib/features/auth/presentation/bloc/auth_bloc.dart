import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  StreamSubscription? _authSubscription;

  AuthBloc(this._authRepository) : super(AuthInitial()) {
    on<AuthStarted>(_onStarted);
    on<AuthSignInRequested>(_onSignIn);
    on<AuthSignUpRequested>(_onSignUp);
    on<AuthSignOutRequested>(_onSignOut);
    on<AuthDeleteAccountRequested>(_onDeleteAccount);
    on<_UserChanged>(_onUserChanged);
    on<_UserLoggedOut>(_onUserLoggedOut);
  }

  void _onStarted(AuthStarted event, Emitter<AuthState> emit) {
    if (_authSubscription != null) return;

    _authSubscription = _authRepository.authStateChanges.listen((user) {
      if (user != null) {
        add(_UserChanged(user));
      } else {
        add(_UserLoggedOut());
      }
    });
  }

  Future<void> _onSignIn(
    AuthSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _authRepository.signIn(event.email, event.password);
    } catch (e) {
      emit(AuthFailure(_parseError(e)));
    }
  }

  Future<void> _onSignUp(
    AuthSignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _authRepository.signUp(event.email, event.password);
    } catch (e) {
      emit(AuthFailure(_parseError(e)));
    }
  }

  Future<void> _onSignOut(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _authRepository.signOut();
    emit(AuthUnauthenticated());
  }

  Future<void> _onDeleteAccount(
    AuthDeleteAccountRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _authRepository.deleteAccount();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthFailure(_parseError(e)));
    }
  }

  void _onUserChanged(_UserChanged event, Emitter<AuthState> emit) {
    emit(AuthAuthenticated(event.user));
  }

  void _onUserLoggedOut(_UserLoggedOut event, Emitter<AuthState> emit) {
    emit(AuthUnauthenticated());
  }

  String _parseError(Object e) {
    final msg = e.toString();
    if (msg.contains('wrong-password') || msg.contains('invalid-credential')) {
      return 'Invalid email or password.';
    } else if (msg.contains('user-not-found')) {
      return 'No account found for this email.';
    } else if (msg.contains('email-already-in-use')) {
      return 'This email is already registered.';
    } else if (msg.contains('network-request-failed')) {
      return 'Network error. Check your connection.';
    } else if (msg.contains('This account has been deleted')) {
      return 'This account has been deleted.';
    }
    return msg;
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}
