USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJRESHDR_sProj]    Script Date: 12/21/2015 13:45:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJRESHDR_sProj] @parm1 varchar (16)   as
select * from PJRESHDR
where project =  @parm1
GO
