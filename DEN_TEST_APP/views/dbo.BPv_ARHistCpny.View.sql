USE [DEN_TEST_APP]
GO
/****** Object:  View [dbo].[BPv_ARHistCpny]    Script Date: 12/21/2015 14:10:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[BPv_ARHistCpny] as

SELECT DISTINCT CpnyID, CustId
  FROM ARHist
GO
