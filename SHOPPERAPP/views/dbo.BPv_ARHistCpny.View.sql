USE [SHOPPERAPP]
GO
/****** Object:  View [dbo].[BPv_ARHistCpny]    Script Date: 12/21/2015 16:12:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[BPv_ARHistCpny] as

SELECT DISTINCT CpnyID, CustId
  FROM ARHist
GO
