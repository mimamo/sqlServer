USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPENTEX_sProj]    Script Date: 12/16/2015 15:55:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPENTEX_sProj] @parm1 varchar (16)   as
Select * from PJPENTEX
where PJPENTEX.project =  @parm1
GO
