USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJPROJEM_DIK0]    Script Date: 12/21/2015 16:13:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPROJEM_DIK0]  @parm1 varchar (10) as
delete from PJPROJEM
where Employee = @parm1
GO
