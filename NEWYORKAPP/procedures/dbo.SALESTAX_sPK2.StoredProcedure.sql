USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[SALESTAX_sPK2]    Script Date: 12/21/2015 16:01:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[SALESTAX_sPK2] @parm1 varchar (10)   as
select * from SALESTAX
where taxid LIKE @parm1
order by taxid, taxtype
GO
