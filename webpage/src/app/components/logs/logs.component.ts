import { Component, OnInit, OnDestroy, ViewChild, ElementRef, ChangeDetectorRef } from '@angular/core';
import { CommonModule } from '@angular/common';

interface LogEntry {
  timestamp: Date;
  message: string;
}

const INITIAL_LOG_COUNT = 10;
const MAX_LOGS = 50;
const LOG_INTERVAL = 2000;

@Component({
  selector: 'app-logs',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './logs.component.html',
  styleUrl: './logs.component.css'
})
export class LogsComponent implements OnInit, OnDestroy {
  @ViewChild('logContainer') private logContainer!: ElementRef;
  
  logs: LogEntry[] = [];
  private interval?: ReturnType<typeof setInterval>;

  constructor(private cdr: ChangeDetectorRef) {}

  private logMessages = [
    'user logged in',
    'api request received',
    'database query executed',
    'cache hit',
    'file uploaded',
    'email sent',
    'session started',
    'webhook received',
    'connection timeout',
    'auth failed',
    'invalid request',
    'database error',
    'file not found',
    'slow query detected',
    'cache miss'
  ];

  ngOnInit(): void {
    for (let i = 0; i < INITIAL_LOG_COUNT; i++) {
      this.addRandomLog();
    }

    this.interval = setInterval(() => {
      this.addRandomLog();
    }, LOG_INTERVAL);
  }

  ngOnDestroy(): void {
    if (this.interval) {
      clearInterval(this.interval);
    }
  }

  private addRandomLog(): void {
    const message = this.logMessages[Math.floor(Math.random() * this.logMessages.length)];
    
    this.logs = [...this.logs, {
      timestamp: new Date(),
      message
    }];

    if (this.logs.length > MAX_LOGS) {
      this.logs = this.logs.slice(1);
    }

    this.cdr.detectChanges();
    setTimeout(() => this.scrollToBottom(), 0);
  }

  private scrollToBottom(): void {
    if (this.logContainer?.nativeElement) {
      this.logContainer.nativeElement.scrollTop = this.logContainer.nativeElement.scrollHeight;
    }
  }
}
