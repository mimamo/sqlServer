USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[xCGS_DelDefaultAddr]    Script Date: 12/21/2015 13:57:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[xCGS_DelDefaultAddr] @DefaultType char(30), @addr_key_cd char(30) AS

	DELETE FROM xCGS_PJADDR WHERE DefaultType = @DefaultType AND addr_key_cd = @addr_key_cd
GO
