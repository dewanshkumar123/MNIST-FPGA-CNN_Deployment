### ES204 Digital Systems
### Indian Institute of Technology, Gandhinagar

### Group Members:-
- Sushant Gudmewar (22110264),
- John Twipraham Debbarma (22110108),
- Parag Sarvoday (22110179) 
- Dewansh Kumar (22110071)

	
# Problem objective: Deployment of a trained CNN model on FPGA for image classification of the MNIST dataset.

 ## Here are the things that we did in this project - A brief summary

 ### Python implementation

 - We got a pre-trained CNN model (weights and biases) which could classify the digits of MNIST dataset. Then we did a forward pass (in Python) by taking the image pixel values (28*28) as input and predicted its class.

 ### Systolic Array based multiplication implementation
- We implemented systolic array multiplication for faster array multiplication process which could also make the convolution much faster.
- We also tweaked the traditional systolic array multiplication algorithm to get the final result in less cycles, thereby making it more efficient.


 ### Verilog Implementation
 Now we had to implement the above task in verilog and predict the digit's class using Nexys4 Board.

 (a) Firstly, we wrote all the required modules in verilog which included - 2D convolution module, max-pooling module, fully - connected layer module.
 
 (b) Then to get the image and other required data, we used BRAM to store the values of image's pixels, weights and biases in memory.

 #### Steps Followed:
 
 - We created a file which consisted of values of images's pixel in binary as it is the required format for reading a file via BRAM. This was achieved by using python function to save a txt file of pixel values in binary. This works as our input.
 
 - Then we did convolution on this matrix of pixel values using 32 kernels of shape 3 * 3. After this we got 32 feature maps of size 26 * 26 (28-3+1, as we did convolution with kernel of shape 3*3).
 
 - Now, max pooling was done on all this 32 feature maps to reduce their size from 26 * 36 to 13 * 13.
 
 - Then this 32 feature maps each of size 13 * 13 was flattened to get a 1D array of size 5408 (32 * 13 * 13).

 - Fully Connected Layer (1st): Applying a fully connected layer with 5408 neurons, which is then connected to a layer with 64 neurons. This step involves matrix multiplication followed by activation function (ReLU).
 
 - Fully Connected Layer (2nd): Applying another fully connected layer with 64 neurons, which is then connected to a layer with 10 neurons. This final layer corresponds to the 10 possible classes (digits 0 through 9 in digit recognition tasks).
 
 - Output Prediction: The output of the network is a vector of size 10, representing the probabilities of each class. The predicted digit is the one with the highest probability.
 
### Challenges Faced:

- We were restricted to make all the data like pixel values, weights, biases and output of all the layers in 8-bit which caused additional work as we had to scale up/down everything so as to fit in 8-bit multiple times, if anywhere data overflew it will lead to totally wrong results.

- Reading data from coe files via BRAM was challenging as many times data couldn't be read properly.

- In one variable, more than 10 lakh bits cannot be stored for synthesis. However, it's possible for simulation. This caused a lot of issues. We had to divide the weights in three parts, which was much time consuming to do our work successfully.

- We can see the simulation result only over a period of 1000 nano-seconds, and this amount of time was elapsed only in reading the data, and hence we couldn't see the other things in simulation which was also a big problem. <br>
  This problem was solved by reducing the time period of clock, which again lead to the new problem that the data was not read properly because of reduced time period of clock in simulation. 
  


 
