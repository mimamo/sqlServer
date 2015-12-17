USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SALESTAX_sPK1]    Script Date: 12/16/2015 15:55:32 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[SALESTAX_sPK1] @parm1 varchar (1) , @PARM2 varchar (10)   as
select * from SALESTAX
where taxtype  LIKE @parm1 and
taxid LIKE @parm2
order by taxid, taxtype
GO
