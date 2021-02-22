--- Get List of Employees
select 
	--distinct
	--Cluster
	A.OOcID
	, C.ClusterID
	--, D.Executive as Executive
	--, D.Position as Position
	, A.UserID as ID
	, B.Surname + ', ' + B.CallName as Name
	, case ltrim(Rtrim(B.Gender))
		when 'M' then 'Male'
		when 'F' then 'Female'
		else 'Other'
		End as Gender
	, IsNull(B.Race, 'X') as EthnicGroup
	, B.Grade
	, B.BranchID as DeptID
	, convert(dateTime, A.EffectiveDate, 103) as EffectiveDate
	, OldTCC
	--, 
	, NewTCC
	, PercentInc
	, Case Ltrim(Rtrim(Status))
		when '' then 'Sitting with HRC to action'
		when 'I' then 'Payroll'
		when 'A' then 'Approved'
		when 'D' then 'Declined'
		when 'P' then 'Pending'
		else 'Other'
		end as Status
--into
--	#tempEmpList
from
	dbo.AddOutOfCycleInc A
	left join OrgPos.dbo.Staff B
		on A.UserID = B.StaffNo
	LEFT OUTER JOIN OrgPos.dbo.vwRollup2 C
		ON B.BranchID = C.BranchID
	--left join #tempClusterExecutive D
	--	on C.ClusterID = D.ClusterID
where
	convert(dateTime, A.EffectiveDate, 103) >= '2009/04/01'
	--and convert(dateTime, A.EffectiveDate, 103) < '2009/05/01'
	and Ltrim(Rtrim(Status)) not in ('', 'D', 'P')

select * from #tempEmpList where Id in (
select ID from #tempEmpList group by ID having count(*) >1)
order by ID

select count(*), count(distinct(ID)) from #tempEmpList
--318	297

select 
	A.*
into
	##tempListDeDupe 
from 
	#tempEmpList A
	inner join (select ID, max(OOcID) MaxOOCID from #tempEmpList group by ID) B
		on A.ID = B.ID and A.OOCID = B.MaxOOcId

select * into ##tempListDeDupe_Rps from ##tempListDeDupe2 order by PercentInc

select * from ##tempListDeDupe_Rps


select convert(varchar(10), EffectiveDate, 121), count(*) from ##tempListDeDupe_Rps
group by convert(varchar(10), EffectiveDate, 121)


---------------------------------------------------------------------------------------------------------------------------------------------------------------------
select
	*
from
	dbo.AddOutOfCycleInc A
where
	convert(dateTime, A.EffectiveDate, 103) >= '2013/01/01'
	--and convert(dateTime, A.EffectiveDate, 103) < '2009/05/01'
	and Ltrim(Rtrim(Status)) not in ('', 'D', 'P')
	aND OOCID in ('16398', '17018', '17325', '17407')