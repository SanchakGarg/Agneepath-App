# agneepath_app
1. First data for all the guests/attendees is stored in a Google sheet as shown below

![](https://lh7-us.googleusercontent.com/4fHIclwaY9SyfLAmKy8QNhTtC_PpEeug7HUz6P1uRteImyUfRfzWT6hN8pENOm-QqlfvGaaotAWj8xL-F8PVLYFZg1OQwEyznzFCdbfsFSxuDBVsyOhUFtfhyArmk8QAisYNuxLaI0Fjd5tS2OT2bFI)

2. Now this Google sheet is connected to a Python script that generates the Unique ID for each attendee and adds all this data to Firebase real-time database in the format shown below.

![](https://lh7-us.googleusercontent.com/z_oGiMXY1CAdnShGsXAWez7bsyFesMbT4Ez2YGSYw1DAhxbNgIOnhglV6OinPn7FdYknlXzoFQnqUX3FD0xHn3VQhbMO8aNEr9tsCkwFOp_ZpCtCIt5TUEzzVMaorKJjtESxmRX5AM-1MqV0WVDqmNM)

3. With the same python script it generate qr code based on the id and includes name and other relevant information.

![](https://lh7-us.googleusercontent.com/8kTH1ynREP-EVS0JUqqrueCY7qW6AeKLWd9lANGo4is-tGMbEeXl_KKQCYslz7LlhovGsPaRMBabdi5DscqJ3a_g_0Y6vxu6T74HB3LdncwMdGEg0M5eGxB8Eg0A2zGQobZnqbxwnjz0jRE8ill3AQE)

4. We scan this QR code through the app which is made by me, so no one else can get access to it except those to whom we send it, and only emails that we have authorised access the app.

5)  This is the home screen here we can select if we want to check in or check out the attendee and then either we can enter the id of the person or scan the qr code which will then redirect us to other page.

![](https://lh7-us.googleusercontent.com/s11114rhL_nXslM3PYNIsuujlMlbQJQrDRw_e6EeL6eEKECe6TD945Zubvdg2aft9u7mBLPe0vrRg2dcsIT-K5FnnzGc3HsKUWz5CYBmxI3OnioBw1jEmIrSMyC2VKx14GXHY1bDwYDZFagMuT1Eqcg)

6. Now after scanning or typing the ID, it pops up on this screen. It displays a photo of the person and other information Now based on what we select we will be shown a check-in or check-out button at the bottom right corner. If the person is already in we try to check in the person again. The app will report an error and show a report button that will be stored  in the database.

![](https://lh7-us.googleusercontent.com/jp8ZcxJko-Shd9fb9OqKlX9wTi7nPosbchRtcAv_t_TBsR1Crxs6hSuIwR-Fxu7sCksq5V2NwGaDxZko_YN9QsrJbBBEliDfrL5BxL3ibuRWaJ7JTa1dz2_O-Ar4bvRS38gwEgB99BH6wjmNj53I8Gw)

7. All this is stored in the excel sheet as logs with the timestamp and name of the person authorising.

![](https://lh7-us.googleusercontent.com/_0vXf2b0EtAPIc8Sz1HSzC0whNkfFqWgFwJHJBfA7i-wh11nFvhHgaIdN3c7Oa79kPZXNF1gkXyjOiDGnL7oyOsbPgFSZ8ARuOpWVXGFOYWPry2s3wHlTy7yx60wpBF6AU6SpW76c1A8MZKISTi7_KI)

8. In the app, there is a dashboard that shows the number of attendees currently in and out and the name + phone number of people who are in.

![](https://lh7-us.googleusercontent.com/9GIwgtb-ysaRoC6smFHX-nt4tbzw--AJsyxrJvlbtnBWihA5Xi3qk0nIYdeas9npS3mL0Eh9WD0Ae9Yd5IOIgSsBJ3eQl4_D6GOF7YR8EXTZpc7XcpZSoU0zwHGaPR8OzhHkGvNX64XQEdwjXxRJDvE)
