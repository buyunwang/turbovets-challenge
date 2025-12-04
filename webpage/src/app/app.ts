import { Component } from '@angular/core';
import { RouterOutlet, RouterLink, RouterLinkActive } from '@angular/router';
import { NgFor, NgClass } from '@angular/common';

@Component({
  selector: 'app-root',
  imports: [RouterOutlet, RouterLink, RouterLinkActive, NgFor, NgClass],
  templateUrl: './app.html',
  styleUrl: './app.css'
})
export class App {
  navItems = [
    { path: '/tickets', label: 'Tickets' },
    { path: '/knowledgebase', label: 'Knowledgebase' },
    { path: '/logs', label: 'Logs' }
  ];
}
