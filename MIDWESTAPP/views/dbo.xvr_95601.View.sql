USE [MIDWESTAPP]
GO
/****** Object:  View [dbo].[xvr_95601]    Script Date: 12/21/2015 15:55:08 ******/
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
FROM DENVERSYS..UserGrp g LEFT JOIN DENVERSYS..UserRec r ON g.UserId = r.UserId
GO
