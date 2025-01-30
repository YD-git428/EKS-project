resource "helm_release" "nginx_ingress" {
  name = "nginx-ingress-controller"

  repository = "https://helm.nginx.com/stable"
  chart      = "nginx-ingress"

  create_namespace = true
  namespace        = "ingress-controller"

}

resource "helm_release" "cert_manager" {
  name = "cert-manager"

  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"

  create_namespace = true
  namespace        = "eks-cert-manager"

  set {
    name  = "installCRDs"
    value = true
  }

  values = [
    "${file("helm-values/cert-manager.yml")}"
  ]

}

resource "helm_release" "external_dns" {
  name       = "external-dns"
  repository = "https://kubernetes-sigs.github.io/external-dns/"
  chart      = "external-dns"

  create_namespace = true
  namespace        = "eks-external-dns"

  set {
    name  = "wait-for"
    value = module.irsa.external_dns_role
  }


  values = [
    file("helm-values/external-dns.yml")
  ]

}

resource "helm_release" "argocd" {
  name       = "argocd-server"
  namespace  = "eks-argocd"
  chart      = "argo-cd"
  repository = "https://argoproj.github.io/argo-helm"
  timeout    = 600

  create_namespace = true


  values = [
    file("helm-values/argocd.yml") 
  ]
}
