USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SALESTAX_sPK0]    Script Date: 12/16/2015 15:55:32 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[SALESTAX_sPK0] @parm1 varchar (10) , @PARM2 varchar (1)   as
select * from SALESTAX
where taxid =  @parm1 and
taxtype  =  @parm2
order by taxid, taxtype
GO
