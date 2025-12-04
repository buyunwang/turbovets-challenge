import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';

@Component({
  selector: 'app-knowledgebase',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './knowledgebase.component.html',
  styleUrl: './knowledgebase.component.css'
})
export class KnowledgebaseComponent {
  markdownContent: string = `# heading 1
## heading 2
### heading 3

regular text

**bold text**
*italic text*

- list item 1
- list item 2

\`code\``;

  isPreviewMode: boolean = false;
  saveMessage: string = '';
  saveTimeout: any;

  togglePreview(): void {
    this.isPreviewMode = !this.isPreviewMode;
  }

  saveContent(): void {
    // Simulate save
    this.saveMessage = 'saved';
    
    // Clear previous timeout
    if (this.saveTimeout) {
      clearTimeout(this.saveTimeout);
    }
    
    // Clear message after 3 seconds
    this.saveTimeout = setTimeout(() => {
      this.saveMessage = '';
    }, 3000);
  }

  convertMarkdownToHtml(markdown: string): string {
    let html = markdown;

    // Headers
    html = html.replace(/^### (.*$)/gim, '<h3 class="text-lg font-bold mt-4 mb-2">$1</h3>');
    html = html.replace(/^## (.*$)/gim, '<h2 class="text-xl font-bold mt-4 mb-2">$1</h2>');
    html = html.replace(/^# (.*$)/gim, '<h1 class="text-2xl font-bold mt-4 mb-2">$1</h1>');

    // Bold
    html = html.replace(/\*\*(.*?)\*\*/gim, '<strong>$1</strong>');

    // Italic
    html = html.replace(/\*(.*?)\*/gim, '<em>$1</em>');

    // Code blocks
    html = html.replace(/```([\s\S]*?)```/gim, '<pre class="bg-gray-100 p-3 rounded my-2 overflow-x-auto"><code>$1</code></pre>');

    // Inline code
    html = html.replace(/`(.*?)`/gim, '<code class="bg-gray-100 px-1 rounded">$1</code>');

    // Links
    html = html.replace(/\[([^\]]+)\]\(([^\)]+)\)/gim, '<a href="$2" class="text-blue-600 hover:underline">$1</a>');

    // Lists
    html = html.replace(/^\- (.*$)/gim, '<li class="ml-4">$1</li>');
    html = html.replace(/(<li.*<\/li>)/s, '<ul class="list-disc my-2">$1</ul>');

    // Line breaks
    html = html.replace(/\n\n/g, '<br><br>');
    html = html.replace(/\n/g, '<br>');

    return html;
  }
}
