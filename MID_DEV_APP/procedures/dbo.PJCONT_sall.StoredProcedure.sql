USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJCONT_sall]    Script Date: 12/21/2015 14:17:48 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJCONT_sall] @parm1 varchar (16)  as
select * from PJCONT
where contract like @parm1
order by contract
GO
