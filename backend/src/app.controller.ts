import { Controller, Get, Post, Body } from '@nestjs/common';
import { AppService } from './app.service';

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Get()
  getHello(): string {
    return this.appService.getHello();
  }

  @Get('data')
  getData() {
    return this.appService.getData();
  }

  @Post('data')
  postData(@Body() body: any) {
    return this.appService.processData(body);
  }
}
