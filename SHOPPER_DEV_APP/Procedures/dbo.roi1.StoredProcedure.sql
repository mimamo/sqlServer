USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[roi1]    Script Date: 12/21/2015 14:34:32 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[roi1] @rptidb smallint           , @rptide smallint            As
Select * from rptruntime
Where rptruntime.RI_ID Between @rptidb and @rptide
Order by RI_ID
GO
