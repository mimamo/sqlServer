USE [SHOPPER_DEV_APP]
GO
/****** Object:  View [dbo].[xvr_95601]    Script Date: 12/21/2015 14:33:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--done
CREATE VIEW [dbo].[xvr_95601]
as
SELECT g.GroupID
, g.UserID
, r.UserName
, r.RecType
FROM DEN_DEV_SYS..UserGrp g LEFT JOIN DEN_DEV_SYS..UserRec r ON g.UserId = r.UserId
GO
