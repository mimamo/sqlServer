USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xValCustProject]    Script Date: 12/21/2015 14:18:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[xValCustProject]
	@parm1 varchar (16)
AS
select Customer from pjproj where Project = @parm1
GO
