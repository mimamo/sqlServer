USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSSBroker_All]    Script Date: 12/21/2015 15:37:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--APPTABLE
CREATE PROCEDURE [dbo].[PSSBroker_All] @parm1 varchar(15) As
  Select * from PSSBroker where BrokerCode like @parm1 order by BrokerCode
GO
