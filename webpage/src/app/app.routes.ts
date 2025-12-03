import { Routes } from '@angular/router';
import { TicketsComponent } from './components/tickets/tickets.component';
import { KnowledgebaseComponent } from './components/knowledgebase/knowledgebase.component';
import { LogsComponent } from './components/logs/logs.component';

export const routes: Routes = [
  { path: '', redirectTo: '/tickets', pathMatch: 'full' },
  { path: 'tickets', component: TicketsComponent },
  { path: 'knowledgebase', component: KnowledgebaseComponent },
  { path: 'logs', component: LogsComponent },
];
