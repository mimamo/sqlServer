USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Select_VO_VM_APDocs]    Script Date: 12/16/2015 15:55:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[Select_VO_VM_APDocs] @parm1 varchar ( 10) As
select * from apdoc
where s4future11 = 'VM'
and doctype = 'VO'
and MasterDocNbr = @parm1
order by refnbr
GO
