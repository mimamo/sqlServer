USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xValCustProject]    Script Date: 12/16/2015 15:55:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[xValCustProject]
	@parm1 varchar (16)
AS
select Customer from pjproj where Project = @parm1
GO
