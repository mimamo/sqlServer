USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[HISTDOCSLSTAX_sPK0]    Script Date: 12/16/2015 15:55:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[HISTDOCSLSTAX_sPK0] @parm1 varchar (10) , @PARM2 varchar (6) , @parm3 varchar (2) , @PARM4 varchar (10)   as
select * from HISTDOCSLSTAX
where taxid   = @parm1 and
YrMon   = @parm2 and
DocType = @parm3 and
RefNbr  = @parm4
order by taxid, YrMon, DocType, RefNbr
GO
