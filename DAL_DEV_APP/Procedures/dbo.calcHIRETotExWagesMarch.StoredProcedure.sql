USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[calcHIRETotExWagesMarch]    Script Date: 12/21/2015 13:35:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[calcHIRETotExWagesMarch]
	@Employee as char(10),
	@Cpny as char(10)
as

Declare @ChkNbr as Char(10),
		@EmpId as Char(10),
		@BatNbr as Char(10),
		@selectSum as Float,
		@returnTotal as Float
		
DECLARE csrHirePRDoc CURSOR FOR 
	Select ChkNbr, EmpId, BatNbr
	From PRDoc
	Where ChkDate >= '3-19-2010' and ChkDate <= '3-31-2010'
		and EmpId = @Employee
		and Rlsed = 1
		and CpnyID = @Cpny
		and S4Future10 = 1

OPEN csrHirePRDoc;

Select @returnTotal = -1;

FETCH NEXT FROM csrHirePRDoc 
INTO @ChkNbr, @EmpId, @BatNbr;

WHILE @@FETCH_STATUS = 0
BEGIN

	Select @selectSum = ISNULL(SUM(CASE Prt.TranType
						WHEN 'VC' THEN (-1 * Prt.RptEarnSubjDed)
						ELSE  Prt.RptEarnSubjDed
						END), 0)
	From PRTran Prt
		Inner Join Deduction Ded
			on Prt.CalYr = Ded.CalYr
			and Prt.EarnDedId = Ded.DedId
	Where Ded.EmpleeDed = '1'
		and Ded.DedType = 'I'
		and Ded.BoxNbr <> '6'
		and Prt.RefNbr = @ChkNbr
		and Prt.EmpId = @EmpId
		and Prt.BatNbr = @BatNbr
		and Prt.Type_ = 'DW'
		and Prt.CpnyID = @Cpny
		
	Select @returnTotal = @returnTotal + @selectSum

	FETCH NEXT FROM csrHirePRDoc
	INTO @ChkNbr, @EmpId, @BatNbr;
END
CLOSE csrHirePRDoc;
DEALLOCATE csrHirePRDoc;

if @returnTotal <> -1
	Select @returnTotal = @returnTotal + 1
	
Select @returnTotal
GO
