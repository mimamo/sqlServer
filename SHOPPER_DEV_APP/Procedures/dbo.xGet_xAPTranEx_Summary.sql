USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xGet_xAPTranEx_Summary]    Script Date: 12/16/2015 15:55:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[xGet_xAPTranEx_Summary] 
AS

--Get records that have not been posted or not Batnbgl
SELECT cpnyid,Batnbrap,Refnbr,ProjectID, TaskID, TaxIndID, Acct, Sub, sum(TaxPrice) from xaptranex
Where Batnbrgl = ''
GROUP BY CpnyID,Batnbrap,Refnbr,ProjectID, TaskID,TaxIndID,Acct, Sub
GO
