package account_domain

import "gke-go-recruiting-server/domain"

type DepartmentOverview struct {
	ID       domain.DepartmentID
	AgencyID domain.AgencyID
	Name     string
}
