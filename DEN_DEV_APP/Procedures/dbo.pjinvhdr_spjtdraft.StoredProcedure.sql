USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[pjinvhdr_spjtdraft]    Script Date: 12/21/2015 14:06:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pjinvhdr_spjtdraft] @parm1 varchar (16), @parm2 varchar(10)  as
select * from pjinvhdr, pjproj where
pjinvhdr.project_billwith like @parm1
and pjinvhdr.draft_num like @parm2
and pjinvhdr.inv_status in ('PO', 'PR')
and pjinvhdr.project_billwith = pjproj.project
order by doctype, draft_num
GO
