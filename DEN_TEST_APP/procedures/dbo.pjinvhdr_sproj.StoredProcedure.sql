USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[pjinvhdr_sproj]    Script Date: 12/21/2015 15:37:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pjinvhdr_sproj] @parm1 varchar (16)  as
select * from pjinvhdr where
pjinvhdr.project_billwith = @parm1
order by invoice_date, invoice_num
GO
