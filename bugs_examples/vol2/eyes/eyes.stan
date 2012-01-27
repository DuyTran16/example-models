// http://www.mrc-bsu.cam.ac.uk/bugs/winbugs/Vol2.pdf
// Page 11: Eyes: Normal Mixture Model 
// 
// 
// from bugs example now, (have not looked at JAGS version yet) 

// FIXME vI: use beta-bernoulli rather than dirichlet-multinomial (done), no bernoulli now 
// FIXME vII: marginalize out z[N] (done) 


// not work yet 

data {
  int(0,) N; 
  double y[N]; 
//  vector(2) alpha;
} 
parameters {
  // int(0,) z[N]; 
  double(0,) sigmasq;
  double(0,) theta;
  double lambda_1; 
  // vector(2) p;
  double(0, 1) p1; 
} 
transformed parameters {
    double lambda[2];
    double sigma; 
    sigma <- sqrt(sigmasq); 
    lambda[1] <- lambda_1;
    lambda[2] <- lambda[1] + theta;
}
/* 
model {
  p ~ dirichlet(alpha); 
  theta ~ normal(0, 1000);  // propto half normal because theta truncated
  lambda_1 ~ normal(0, 1e3); 
  sigmasq ~ inv_gamma(1e-3, 1e-3); 
  for (n in 1:N) {
    z[n] ~ categorical(p);
    y[n] ~ normal(lambda[z[n]], sqrt(sigmasq)); 
  }
}
*/

model {
  // p1 ~ beta(alpha[1], alpha[2]); 
  p1 ~ beta(1, 1); 
  theta ~ normal(0, 100); 
  lambda_1 ~ normal(0, 1e3); 
  sigmasq ~ inv_gamma(1e-3, 1e-3); 
  for (n in 1:N) {
    lp__ <- lp__ + 
            log_sum_exp(log(p1) + normal_log(y[n], lambda[1], sigma), 
                        log(1 - p1) + normal_log(y[n], lambda[2], sigma)); 
  }
} 

