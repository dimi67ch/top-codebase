# Give users access to your Kubernetes cluster

In this chapter we explain how you can give users from outside secure access to your Kubernetes cluster.

## Playbook

Before you run the Ansible playbook, you can determine how many user accounts you want to create in the `codebase/ansible/group_vars/all.yml` file:

```yaml
usercount: 3
```

in this case we want to create `3` user accounts.\
The playbooks's `k8s_rbac` role will initially **create a namespace for each user**.

> The namespace will be named "user\<n>" 

With Kubernetes' Role Based Access Control **(RBAC)** we defined that every user has **only access to their own namespace**. The playbook implements this with **Roles** and **RoleBindings**.

Due to **authentication** reasons the playbook creates a **key pair** for every user, such as a certificate signing request (**CSR**). The Kubernetes CA will afterwards sign the certificates of the users.

> The key will be named "user\<n>.key"

> The certificate will be named "user\<n>.crt"

> **Note:** The certificate is valid for 2 weeks!

To protect the keys and certificates of each user, we **copy** them to the host machine (which executes the playbook) and eventually **delete** them from the Kubernetes host machine.

### Change the number of user accounts

If you change `usercount` to a **bigger** number:
- the additional user accounts will be added (from user1 to user\<n>).

If you change `usercount` to a **lower** number:
- the playbook will ask you which of the user accounts you want to remove
- **for example**: if you change the `usercount` from **5** to **3** and you want to remove user account **user1** and **user4** you type in:
```bash
1,4
```
and the playbook will delete **user1** and **user4** (and their **namespaces**).

If you change `usercount` to **0**:
- The playbook deletes every user and their namespace.

## How users can access their namespace

See [chapter "kubernetes-kubectl-for-users"](./kubernetes-kubectl-for-users.md).

## How admins can access the cluster

To access the cluster as an administrator, you have to connect to the Kubernetes host machine via **ssh**.