USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJBSDET_sProj]    Script Date: 12/21/2015 16:13:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJBSDET_sProj]  @parm1 varchar (16)  as
select * from PJBSDET
where    PJBSDET.Project = @parm1
GO
