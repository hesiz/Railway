# Overview

This is a complete FastAPI server project that integrates with Ollama to provide AI chat functionality using the TinyLlama model (~1B parameters, ~400MB). The server acts as a REST API wrapper around Ollama, automatically handling installation, setup, and management of the Ollama service and TinyLlama model. It provides a simple POST `/chat` endpoint for users to interact with the AI model, along with health checks and comprehensive error handling.

**Project Status**: ✅ COMPLETE and FUNCTIONAL
- Server running on http://0.0.0.0:5000 (Replit compatible)
- POST /chat endpoint working with JSON requests/responses
- Health checks at /health endpoint
- Automatic API documentation at /docs
- Docker containerization ready
- All dependencies properly installed

# User Preferences

Preferred communication style: Simple, everyday language.
Project requirements: Complete Python project under 1GB, fully functional with auto-start capabilities.

# System Architecture

## API Framework
- **FastAPI**: Chosen as the web framework for its automatic API documentation, type validation, and async support
- **Pydantic Models**: Used for request/response validation and serialization (ChatRequest, ChatResponse, HealthResponse)
- **CORS Middleware**: Configured to allow cross-origin requests for web client integration

## AI Integration Layer
- **Ollama Integration**: The server manages Ollama as the local LLM runtime environment
- **TinyLlama Model**: Selected as the lightweight language model for chat functionality
- **Automatic Setup**: Server handles Ollama installation and model downloading automatically
- **Service Management**: Includes health checks and status monitoring for the Ollama service

## HTTP Client Architecture
- **Dual HTTP Client Support**: Uses both `requests` (synchronous) and `httpx` (asynchronous) libraries
- **External API Communication**: Communicates with Ollama's REST API endpoints
- **Error Handling**: Comprehensive error handling for model interactions and service availability

## Server Infrastructure
- **ASGI Server**: Uses Uvicorn as the production-ready ASGI server
- **Background Tasks**: Supports background task processing for model management operations
- **REST API Design**: Simple, intuitive endpoint structure focused on chat functionality

# External Dependencies

## Core Framework Dependencies
- **FastAPI** (>=0.104.1): Web framework for building the REST API
- **Uvicorn** (with standard extras >=0.24.0): ASGI server for running the application
- **Pydantic** (>=2.0.0): Data validation and serialization

## HTTP Client Libraries
- **requests** (>=2.31.0): Synchronous HTTP client for Ollama API communication
- **httpx** (>=0.25.0): Asynchronous HTTP client for modern async operations

## AI/ML Service Integration
- **Ollama**: Local LLM runtime (automatically installed and managed by the application)
- **TinyLlama Model**: Lightweight language model downloaded through Ollama

## System Dependencies
- **Python 3.x**: Runtime environment
- **Subprocess Management**: For Ollama installation and service control
- **File System Access**: For managing Ollama installation and model storage