import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';

type TicketStatus = 'Open' | 'In Progress' | 'Closed';
type FilterOption = 'All' | TicketStatus;

interface Ticket {
  id: string;
  subject: string;
  status: TicketStatus;
  createdAt: Date;
}

const STATUS_CLASSES: Record<TicketStatus, string> = {
  'Open': 'bg-blue-100 text-blue-800',
  'In Progress': 'bg-yellow-100 text-yellow-800',
  'Closed': 'bg-green-100 text-green-800'
};

@Component({
  selector: 'app-tickets',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './tickets.component.html',
  styleUrl: './tickets.component.css'
})
export class TicketsComponent {
  readonly filters: FilterOption[] = ['All', 'Open', 'In Progress', 'Closed'];
  
  allTickets: Ticket[] = [
    { id: '#001', subject: 'cant login', status: 'Open', createdAt: new Date('2024-12-01T09:15:00') },
    { id: '#002', subject: 'payment issue', status: 'In Progress', createdAt: new Date('2024-12-01T10:30:00') },
    { id: '#003', subject: 'no email received', status: 'Closed', createdAt: new Date('2024-11-30T14:20:00') },
    { id: '#004', subject: 'app keeps crashing', status: 'Open', createdAt: new Date('2024-12-02T08:45:00') },
    { id: '#005', subject: 'issue with receipt', status: 'In Progress', createdAt: new Date('2024-12-02T11:10:00') },
    { id: '#006', subject: 'need refund', status: 'Closed', createdAt: new Date('2024-11-29T16:30:00') },
    { id: '#007', subject: 'cant update profile', status: 'Open', createdAt: new Date('2024-12-03T07:20:00') },
    { id: '#008', subject: 'charged twice', status: 'In Progress', createdAt: new Date('2024-12-03T09:00:00') },
    { id: '#009', subject: 'cant export data', status: 'Closed', createdAt: new Date('2024-11-28T13:45:00') },
    { id: '#010', subject: 'notifications stopped', status: 'Open', createdAt: new Date('2024-12-03T10:15:00') },
  ];

  selectedFilter: FilterOption = 'All';

  get filteredTickets(): Ticket[] {
    if (this.selectedFilter === 'All') {
      return this.allTickets;
    }
    return this.allTickets.filter(ticket => ticket.status === this.selectedFilter);
  }

  setFilter(filter: FilterOption): void {
    this.selectedFilter = filter;
  }

  getStatusClass(status: TicketStatus): string {
    return STATUS_CLASSES[status];
  }
}
