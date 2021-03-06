BEGIN TRY
BEGIN TRANSACTION;
	
Declare @N1 INT
SET @N1 = 6

Declare @N2 INT
SET @N2 = 8

Declare @disciplina VARCHAR(50)
SET @disciplina = 'Baze de date'

Declare @tipEvaluare VARCHAR(50);
SET @tipEvaluare = 'Testul 1';

Declare @indexNr INT;
SET @indexNr = 100;
Declare @until INT;
SET @until = 0;

 WHILE @until < 10 
	BEGIN
	DECLARE @grade INT;
	SET @grade = (SELECT nota FROM studenti_reusita AS sr
	JOIN discipline ON discipline.Id_Disciplina = sr.Id_Disciplina
	WHERE sr.Id_Student = @indexNr AND discipline.Disciplina = @disciplina AND sr.Tip_Evaluare = @tipEvaluare)
	
	IF @grade != @N1 and @grade != @N2
	BEGIN
			DECLARE @name  VARCHAR(50)
			SET @name = (
			SELECT Nume_Student FROM studenti WHERE studenti.Id_Student = @indexNr
			)
			DECLARE @lastName VARCHAR(50)
			SET @lastName = (
			SELECT Prenume_Student FROM studenti WHERE studenti.Id_Student = @indexNr
			)
			PRINT  @name + ' ' + @lastName + ' has grade ' + CAST(@grade AS VARCHAR(2));
	END	
SET @indexNr = @indexNr + 1
SET @until = @until + 1
END 

COMMIT TRANSACTION;
END TRY

BEGIN CATCH
IF @@TRANCOUNT > 0
ROLLBACK TRANSACTION

DECLARE @ErrorNumber INT = ERROR_NUMBER();
DECLARE @ErrorLine INT = ERROR_LINE();
DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
DECLARE @ErrorState INT = ERROR_STATE();

PRINT 'Actual error number: ' + CAST(@ErrorNumber AS VARCHAR(10));
PRINT 'Actual line number: ' + CAST(@ErrorLine AS VARCHAR(10));

RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
END CATCH