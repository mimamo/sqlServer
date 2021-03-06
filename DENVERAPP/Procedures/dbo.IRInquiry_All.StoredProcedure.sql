USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[IRInquiry_All]    Script Date: 12/21/2015 15:42:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Procedure [dbo].[IRInquiry_All] @ComputerName VarChar(21), @DateStartFrom SmallDateTime, @DateStartTo SmallDateTime, @DateEndFrom smalldatetime, @DateEndTo SmallDateTime, @Revised SmallInt as
Select * from IRInquiry where ComputerName like @ComputerName and DateStart between @DateStartFrom and @DateStartTo and DateEnd between @DateEndFrom and @DateEndTo and Revised = @Revised
	Order by ComputerName, DateStart, DateEnd
GO
