#!/usr/bin/env bash

scenarios=simple_tag
seeds=0
models='baseline sa'
adversaries='1 2 3 4 5'
num_episodes=60000


source venv/bin/activate

for seed in $seeds;do
    for scenario in $scenarios;do
        for model in $models;do
            for adv in $adversaries;do
                echo "model: $model, scenario: $scenario, seed:$seed"
                exp_name="${model}-${scenario}-n_adv-${adv}-${seed}"
                python experiments/train.py --num-episodes $num_episodes --num-adversaries $adv --scenario $scenario --model $model --seed $seed --exp-name $exp_name
            done
        done
    done
done


#In all of our experiments, we use the Adam optimizer with a learning rate of 0.01 and τ = 0:01 for
#updating the target networks. γ is set to be 0.95. The size of the replay buffer is 106 and we update
#the network parameters after every 100 samples added to the replay buffer. We use a batch size of
#1024 episodes before making an update, except for TRPO where we found a batch size of 50 lead to
#better performance (allowing it more updates relative to MADDPG). We train with 10 random seeds
#for environments with stark success/ fail conditions (cooperative communication, physical deception,
#and covert communication) and 3 random seeds for the other environments.
