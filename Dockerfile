# Using Python 3.10 to avoid asyncio.coroutine issues
FROM python:3.10-slim-buster

RUN apt-get update && apt-get install -y gcc python3-dev libffi-dev netcat && rm -rf /var/lib/apt/lists/*

RUN pip install --upgrade pip

ENV USER botx
ENV HOME /home/$USER
ENV BOT $HOME/media-search-bot

RUN useradd -m $USER
RUN mkdir -p $BOT
RUN chown $USER:$USER $BOT
USER $USER
WORKDIR $BOT

COPY requirements.txt requirements.txt
RUN pip install --user --no-cache-dir -r requirements.txt

COPY . .

# Start netcat in the background to keep port 8000 open for health checks
CMD (nc -lkp 8000 & ) && python3 bot.py
