import { Injectable } from '@nestjs/common';

@Injectable()
export class AppService {
  getHello(): string {
    return 'Hello World!';
  }

  getData() {
    return {
      message: 'Data fetched successfully',
      data: {
        id: 1,
        name: 'Ashish Shah',
        role: 'Developer',
        status: 'Active'
      }
    };
  }

  processData(data: any) {
    console.log('Received data in backend:', data);
    return {
      message: 'Data processed successfully',
      echo: data,
      timestamp: new Date().toISOString()
    };
  }
}
