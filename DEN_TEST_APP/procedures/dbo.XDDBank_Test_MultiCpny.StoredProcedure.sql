USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDBank_Test_MultiCpny]    Script Date: 12/21/2015 15:37:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDBank_Test_MultiCpny]
AS
   SELECT		Count(Distinct CpnyID)
   FROM			XDDBank (NoLock)
   WHERE		FormatID = 'US-ACH'
GO
