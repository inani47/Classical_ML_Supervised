clc
clear all
%% Load Data 
load('data.mat')
data = reshape(face,[],600)';
% data = zscore(data);  % Standardize the data to have 0 mean and std 1
%% Test-Train Split
test_data = data(2:3:end,:);
train_data = data;
train_data(2:3:end,:) = [];
[train_len,data_dim] = size(train_data);
y_test = (1:200)';
y_train = repelem(y_test,2); 
M = 200;
%% LDA
out_dim = 125;
M_0 = mean(train_data,1);
Mu_m = zeros(M,data_dim);
C_m = zeros(data_dim,data_dim,M);
for j = 0:M-1
    Mu_m(j+1,:) = mean(train_data(j*2+1:j*2+2,:),1);
    C_m(:,:,j+1) = cov([train_data(j*2+1,:);train_data(j*2+2,:)]);
end
theta_F = LDA_fun(M_0,Mu_m,C_m,M,out_dim);
train_data = (theta_F'*train_data')';
test_data = (theta_F'*test_data')';
[train_len,data_dim] = size(train_data);
[test_len,~] = size(test_data);
%% Compute the Maximum Likelihood Estimates
Mu = zeros(M,data_dim);
C = zeros(data_dim,data_dim,M);
for j = 0:M-1
    Mu(j+1,:) = mean(train_data(j*2+1:j*2+2,:),1);
    C(:,:,j+1) = cov([train_data(j*2+1,:);train_data(j*2+2,:)]);
end
C = C + eye(data_dim,data_dim); % Add identity matrix to make Covariance Matrices Invertible
%% Training Accuracy
[train_accuracy,test_accuracy] = Bayes_Classisifer_fun(Mu,C,train_data,test_data,y_train,y_test,M);

disp('The training accuracy for Bayes is ');
disp(train_accuracy);

disp('The testing accuracy for Bayes is ');
disp(test_accuracy);