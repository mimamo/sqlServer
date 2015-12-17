USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[pjinvhdr_spk4]    Script Date: 12/16/2015 15:55:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
--Modified approver to come from pjinvhdr.  BK 05/06/04 DE 235445, PCL 1976
Create Procedure [dbo].[pjinvhdr_spk4] @parm1 varchar (10)  as
select
PJINVHDR.*,
PJBILL.*,
PJPROJ.*,
CUSTOMER.custid, CUSTOMER.name
from
PJINVHDR,
PJBILL,
PJPROJ,
CUSTOMER
where
pjinvhdr.project_billwith  =  pjbill.project AND
pjproj.project  =  pjinvhdr.project_billwith and
customer.custid =  pjinvhdr.customer and
pjinvhdr.approver_id = @parm1 and
pjinvhdr.inv_status = 'CO'
order by pjinvhdr.draft_num
GO
