USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJSUBVEN_sall]    Script Date: 12/21/2015 15:43:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJSUBVEN_sall] @parm1 varchar (15)  as
select * from PJSUBVEN
where vendid like @parm1
order by vendid
GO
