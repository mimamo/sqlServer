USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJSUBDET_sProj]    Script Date: 12/21/2015 13:35:50 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJSUBDET_sProj]  @parm1 varchar (16)   as
select * from PJSUBDET
where
PJSUBDET.project       =    @parm1
GO
