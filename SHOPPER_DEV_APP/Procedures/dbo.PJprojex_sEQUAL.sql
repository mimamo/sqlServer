USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJprojex_sEQUAL]    Script Date: 12/16/2015 15:55:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJprojex_sEQUAL] @parm1 varchar (16)  as
select * from PJprojex
where project = @parm1
order by project
GO
