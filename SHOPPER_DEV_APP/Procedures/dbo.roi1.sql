USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[roi1]    Script Date: 12/16/2015 15:55:31 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[roi1] @rptidb smallint           , @rptide smallint            As
Select * from rptruntime
Where rptruntime.RI_ID Between @rptidb and @rptide
Order by RI_ID
GO
