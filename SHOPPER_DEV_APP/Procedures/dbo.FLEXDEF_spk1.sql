USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[FLEXDEF_spk1]    Script Date: 12/16/2015 15:55:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[FLEXDEF_spk1] @parm1 varchar (15)  as
select * from FLEXDEF
where   FieldClassName = @parm1
order by FieldClassName
GO
