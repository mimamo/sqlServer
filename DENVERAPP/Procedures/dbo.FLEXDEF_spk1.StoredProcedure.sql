USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[FLEXDEF_spk1]    Script Date: 12/21/2015 15:42:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[FLEXDEF_spk1] @parm1 varchar (15)  as
select * from FLEXDEF
where   FieldClassName = @parm1
order by FieldClassName
GO
