# TURN Server

coTURN 기반의 Docker 컨테이너 TURN 서버입니다. NAT/방화벽 환경에서 WebRTC 미디어 릴레이를 제공합니다.

## 기술 스택

| 항목 | 기술 |
|------|------|
| 컨테이너 | Docker |
| 베이스 이미지 | instrumentisto/coturn |
| TURN 서버 | coTURN |

## 포트

| 포트 | 프로토콜 | 용도 |
|------|----------|------|
| 3478 | TCP/UDP | STUN/TURN |
| 5349 | TCP/UDP | TURN TLS |
| 49152-65535 | UDP | 미디어 릴레이 |

## 프로젝트 구조

```
turn-server/
├── Dockerfile-local       # Local 환경 Docker 빌드 설정
├── Dockerfile-dev         # Dev 환경 Docker 빌드 설정
├── Dockerfile-prd         # Prd 환경 Docker 빌드 설정
├── turnserver-local.conf  # Local 환경 coTURN 설정 파일
├── turnserver-dev.conf    # Dev 환경 coTURN 설정 파일
└── turnserver-prd.conf    # Prd 환경 coTURN 설정 파일
```

## 설정 (turnserver.conf)

| 항목 | 값 | 설명 |
|------|-----|------|
| 인증 방식 | `lt-cred-mech` | Long-term credential |
| 사용자 | `user1:pass1` | ICE 서버 인증 계정 |
| Realm | `localhost` | TURN 도메인 |
| Listening IP | `0.0.0.0` | 모든 인터페이스 |
| External IP | `127.0.0.1` | 외부 공개 IP |
| 릴레이 포트 | `49152-65535` | UDP 릴레이 범위 |
| Fingerprint | 활성화 | DTLS 지문 검증 |

> 운영 환경에서는 `external-ip`를 실제 공인 IP로 변경하고, 사용자 계정을 안전하게 관리해야 합니다.

## 실행 방법

### Local 환경

```bash
# Docker 이미지 빌드
docker build -t turn-server-local -f Dockerfile-local .

# Docker 컨테이너 실행
docker run -d --name turn-server-local \
  -p 3478:3478 -p 3478:3478/udp \
  -p 5349:5349 -p 5349:5349/udp \
  turn-server-local
```

### Dev 환경

```bash
# Docker 이미지 빌드
docker build -t turn-server-dev -f Dockerfile-dev .

# Docker 컨테이너 실행
docker run -d --name turn-server-dev \
  -p 3478:3478 -p 3478:3478/udp \
  -p 5349:5349 -p 5349:5349/udp \
  turn-server-dev
```

### Prd 환경

```bash
# Docker 이미지 빌드
docker build -t turn-server-prd -f Dockerfile-prd .

# Docker 컨테이너 실행
docker run -d --name turn-server-prd \
  -p 3478:3478 -p 3478:3478/udp \
  -p 5349:5349 -p 5349:5349/udp \
  turn-server-prd
```

### 컨테이너 관리

```bash
# Local
docker stop turn-server-local      # 정지
docker start turn-server-local     # 재시작
docker rm turn-server-local        # 삭제
docker logs turn-server-local      # 로그 확인

# Dev
docker stop turn-server-dev        # 정지
docker start turn-server-dev       # 재시작
docker rm turn-server-dev          # 삭제
docker logs turn-server-dev        # 로그 확인

# Prd
docker stop turn-server-prd        # 정지
docker start turn-server-prd       # 재시작
docker rm turn-server-prd          # 삭제
docker logs turn-server-prd        # 로그 확인
```

## 클라이언트 연결 설정

프론트엔드에서 ICE 서버로 사용:

```javascript
const ICE_SERVERS = [
  { urls: 'stun:127.0.0.1:3478' },
  { urls: 'turn:127.0.0.1:3478', username: 'user1', credential: 'pass1' }
];
```

---

## Legacy

```
docker build -t turn-server .


docker run -d --name turn-server \
  -p 3478:3478 -p 3478:3478/udp \
  -p 5349:5349 -p 5349:5349/udp \
  turn-server
```
