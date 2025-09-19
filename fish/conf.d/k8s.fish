function k
	command kubectl $argv
end
function kshell
	command kubectl run -i --tty --rm geoffo-debug --image=nicolaka/netshoot --restart=Never --annotations='cluster-autoscaler.kubernetes.io/safe-to-evict="true"' -- sh $argv
end
function ky
	command kubectl get -o yaml $argv
end
function kl
	command kubectl logs $argv
end
function ke
	command kubectl edit $argv
end
function kg
	command kubectl get $argv
end
function kga
	command kubectl get --all-namespaces $argv
end
function kd
	command kubectl describe $argv
end
function kl
	command kubectl logs $argv
end
function kn
	command kubectl config set-context --current --namespace $argv
end
function kx
	command kubectl exec -ti $argv
end
function kgn
	command kubectl api-resources --verbs=list --namespaced -o name  | xargs -n 1 kubectl get --show-kind --ignore-not-found  -n $argv
end


