USE [SHOPPER_TEST_APP]
GO
/****** Object:  View [dbo].[BPv_APHistCpny]    Script Date: 12/21/2015 16:06:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[BPv_APHistCpny] as

SELECT DISTINCT CpnyID, VendId
  FROM APHist
GO
